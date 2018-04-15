package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "mode_state_default_param")
@Entity(name = "mildred$ModeStateDefaultParam")
public class ModeStateDefaultParam extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 1126576126126158304L;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "mode_state_default_id")
    protected ModeStateDefault modeStateDefault;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @Column(name = "value", nullable = false, length = 1024)
    protected String value;

    public void setModeStateDefault(ModeStateDefault modeStateDefault) {
        this.modeStateDefault = modeStateDefault;
    }

    public ModeStateDefault getModeStateDefault() {
        return modeStateDefault;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }


}