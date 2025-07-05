package com.tyyago.service;

import io.smallrye.mutiny.Uni;
import io.vertx.mutiny.pgclient.PgPool;
import io.vertx.mutiny.sqlclient.Tuple;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class FieldService {

    @Inject
    PgPool client;

    public Uni<String> updateField(String workItemId, String field, String value) {
        String user = "system";
        return client.withTransaction(conn ->
            conn.preparedQuery("SELECT current_value FROM sm_field_state WHERE work_item_id=$1 AND field_name=$2")
                    .execute(Tuple.of(workItemId, field))
                    .map(rs -> rs.iterator().hasNext() ? rs.iterator().next().getString("current_value") : null)
                    .flatMap(old -> conn.preparedQuery("INSERT INTO sm_field_event(work_item_id, field_name, old_value, new_value, user_id) VALUES ($1,$2,$3,$4,$5)")
                            .execute(Tuple.of(workItemId, field, old, value, user))
                            .flatMap(x -> conn.preparedQuery("INSERT INTO sm_field_state(work_item_id, field_name, current_value, last_modified_by) VALUES ($1,$2,$3,$4) ON CONFLICT (work_item_id, field_name) DO UPDATE SET current_value=EXCLUDED.current_value, last_modified_by=EXCLUDED.last_modified_by, last_modified_at=now()")
                                    .execute(Tuple.of(workItemId, field, value, user))
                                    .map(r -> value))
                    )
        );
    }

    public Uni<Void> revertEvent(java.util.UUID id) {
        String user = "system";
        return client.withTransaction(conn ->
            conn.preparedQuery("SELECT * FROM sm_field_event WHERE id=$1")
                    .execute(Tuple.of(id))
                    .flatMap(rs -> {
                        if (!rs.iterator().hasNext()) {
                            return Uni.createFrom().voidItem();
                        }
                        var row = rs.iterator().next();
                        String workItemId = row.getString("work_item_id");
                        String field = row.getString("field_name");
                        String oldValue = row.getString("old_value");
                        String newValue = row.getString("new_value");
                        return conn.preparedQuery("INSERT INTO sm_field_event(work_item_id, field_name, old_value, new_value, user_id) VALUES ($1,$2,$3,$4,$5)")
                                .execute(Tuple.of(workItemId, field, newValue, oldValue, user))
                                .flatMap(x -> conn.preparedQuery("UPDATE sm_field_event SET reverted=true WHERE id=$1")
                                        .execute(Tuple.of(id)))
                                .flatMap(x -> conn.preparedQuery("UPDATE sm_field_state SET current_value=$1, last_modified_by=$2, last_modified_at=now() WHERE work_item_id=$3 AND field_name=$4")
                                        .execute(Tuple.of(oldValue, user, workItemId, field)))
                                .map(r -> null);
                    })
        );
    }
}
