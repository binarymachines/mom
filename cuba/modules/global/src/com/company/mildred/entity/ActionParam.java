package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "action_param")
@Entity(name = "mildred$ActionParam")
public class ActionParam extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 4897677824220334193L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "action_id")
    protected Action action;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "vector_param_id")
    protected VectorParam vectorParam;

    @Column(name = "value", length = 1024)
    protected String value;

    public void setAction(Action action) {
        this.action = action;
    }

    public Action getAction() {
        return action;
    }

    public void setVectorParam(VectorParam vectorParam) {
        this.vectorParam = vectorParam;
    }

    public VectorParam getVectorParam() {
        return vectorParam;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }


}