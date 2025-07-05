package com.tyyago.resource;

import com.tyyago.service.FieldService;
import io.smallrye.mutiny.Uni;
import jakarta.inject.Inject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

import java.util.UUID;

@Path("/event")
@Produces(MediaType.TEXT_HTML)
@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
public class EventResource {

    @Inject
    FieldService fieldService;

    @POST
    @Path("{id}/revert")
    public Uni<String> revert(@PathParam("id") UUID id) {
        return fieldService.revertEvent(id).replaceWith("Reverted");
    }
}
