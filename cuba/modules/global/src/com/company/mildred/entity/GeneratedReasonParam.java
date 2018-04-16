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
@Table(name = "generated_reason_param")
@Entity(name = "mildred$GeneratedReasonParam")
public class GeneratedReasonParam extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -2036848733601123340L;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "reason_id")
    protected GeneratedReason reason;

    @Column(name = "value", length = 1024)
    protected String value;

    public void setReason(GeneratedReason reason) {
        this.reason = reason;
    }

    public GeneratedReason getReason() {
        return reason;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }


}