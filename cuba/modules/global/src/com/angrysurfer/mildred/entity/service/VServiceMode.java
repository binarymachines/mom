package com.angrysurfer.mildred.entity.service;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import com.angrysurfer.mildred.entity.service.key.VServiceModeCompKey;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import com.haulmont.cuba.core.entity.BaseGenericIdEntity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.annotation.Lookup;
import com.haulmont.cuba.core.entity.annotation.LookupType;

@DesignSupport("{'imported':true}")
@Table(name = "v_service_mode")
@Entity(name = "mildred$VServiceMode")
public class VServiceMode extends BaseGenericIdEntity<VServiceModeCompKey> {
    private static final long serialVersionUID = 5990181518569880978L;

    @EmbeddedId
    protected VServiceModeCompKey id;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "service_profile_id")
    protected ServiceProfile serviceProfile;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "mode_id")
    protected Mode mode;

    public ServiceProfile getServiceProfile() {
        return serviceProfile;
    }

    public void setServiceProfile(ServiceProfile serviceProfile) {
        this.serviceProfile = serviceProfile;
    }


    public Mode getMode() {
        return mode;
    }

    public void setMode(Mode mode) {
        this.mode = mode;
    }


    @Override
    public VServiceModeCompKey getId() {
        return id;
    }

    @Override
    public void setId(VServiceModeCompKey id) {
        this.id = id;
    }


}