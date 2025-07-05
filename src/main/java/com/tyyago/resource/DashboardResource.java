package com.tyyago.resource;

import com.tyyago.service.WorkItemService;
import io.quarkus.qute.Template;
import io.quarkus.qute.TemplateInstance;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/dashboard")
public class DashboardResource {

    @Inject
    Template dashboard;

    @Inject
    WorkItemService workItemService;

    @GET
    @Produces(MediaType.TEXT_HTML)
    public TemplateInstance get() {
        return dashboard.data("items", workItemService.fetchAllWithState());
    }
}
