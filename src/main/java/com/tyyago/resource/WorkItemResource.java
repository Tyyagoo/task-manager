package com.tyyago.resource;

import com.tyyago.service.FieldService;
import io.smallrye.mutiny.Uni;
import io.vertx.core.json.JsonObject;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

import java.util.Map;

@Path("/work-item")
@Produces(MediaType.TEXT_HTML)
@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
public class WorkItemResource {

    @Inject
    FieldService fieldService;

    @GET
    @Path("{id}/edit-field/{field}")
    public String editForm(@PathParam("id") String id, @PathParam("field") String field) {
        return "<input name=\"value\" hx-post=\"/work-item/" + id + "/edit-field/" + field + "\" hx-target=\"this\" hx-swap=\"outerHTML\" value=\"\"/>";
    }

    @POST
    @Path("{id}/edit-field/{field}")
    public Uni<String> update(@PathParam("id") String id, @PathParam("field") String field, @FormParam("value") String value) {
        return fieldService.updateField(id, field, value).map(v -> "<span hx-get=\"/work-item/" + id + "/edit-field/" + field + "\" hx-target=\"this\" hx-swap=\"outerHTML\">" + v + "</span>");
    }
}
