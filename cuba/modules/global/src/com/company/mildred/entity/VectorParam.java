package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "vector_param")
@Entity(name = "mildred$VectorParam")
public class VectorParam extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -2365176104421948996L;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }


}