package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "reason_param")
@Entity(name = "mildred$ReasonParam")
public class ReasonParam extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 5811650103217366883L;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "reason_id")
    protected Reason reason;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "vector_param_id")
    protected VectorParam vectorParam;

    @Column(name = "value", length = 1024)
    protected String value;

    public void setReason(Reason reason) {
        this.reason = reason;
    }

    public Reason getReason() {
        return reason;
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