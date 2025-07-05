package com.tyyago.service;

import io.smallrye.mutiny.Uni;
import io.vertx.mutiny.pgclient.PgPool;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import java.util.List;
import java.util.stream.Collectors;

import com.tyyago.model.WorkItem;

@ApplicationScoped
public class WorkItemService {

    @Inject
    PgPool client;

    public Uni<List<WorkItemWithState>> fetchAllWithState() {
        String sql = """
                SELECT w.id, w.summary, w.managing_unit, w.priority, w.external_status,
                       w.creation_date, w.resolution_date, w.planned_date, w.demand_type,
                       w.backlog_type, w.modified_date, w.modified_by, w.parent,
                       s_status.current_value AS status,
                       s_action.current_value AS current_action
                  FROM work_item w
                  LEFT JOIN sm_field_state s_status ON w.id = s_status.work_item_id AND s_status.field_name='status'
                  LEFT JOIN sm_field_state s_action ON w.id = s_action.work_item_id AND s_action.field_name='current_action'
                  ORDER BY w.id""";
        return client.query(sql)
                .execute()
                .map(rs -> rs.stream().map(row -> new WorkItemWithState(
                        new WorkItem(
                                row.getString("id"),
                                row.getString("summary"),
                                row.getString("managing_unit"),
                                row.getString("priority"),
                                row.getString("external_status"),
                                row.getLocalDate("creation_date"),
                                row.getLocalDate("resolution_date"),
                                row.getLocalDate("planned_date"),
                                row.getString("demand_type"),
                                row.getString("backlog_type"),
                                row.getLocalDate("modified_date"),
                                row.getString("modified_by"),
                                row.getString("parent")
                        ),
                        row.getString("status"),
                        row.getString("current_action")
                )).collect(Collectors.toList()));
    }

    public record WorkItemWithState(WorkItem item, String status, String currentAction) {}
}
