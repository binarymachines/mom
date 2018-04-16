package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true,'unmappedColumns':['vector_param_id']}")
@Table(name = "generated_action_param")
@Entity(name = "mildred$GeneratedActionParam")
public class GeneratedActionParam extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 1569761896180546984L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "action_id")
    protected GeneratedAction action;

    @Column(name = "value", length = 1024)
    protected String value;

    public void setAction(GeneratedAction action) {
        this.action = action;
    }

    public GeneratedAction getAction() {
        return action;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }


}