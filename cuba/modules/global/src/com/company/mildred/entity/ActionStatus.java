package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "action_status")
@Entity(name = "mildred$ActionStatus")
public class ActionStatus extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -8860832025399156642L;

    @Column(name = "name")
    protected String name;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }


}