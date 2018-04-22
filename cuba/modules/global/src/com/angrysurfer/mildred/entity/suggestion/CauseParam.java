package com.angrysurfer.mildred.entity.suggestion;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true,'unmappedColumns':['vector_param_id']}")
@Table(name = "cause_param")
@Entity(name = "mildred$CauseParam")
public class CauseParam extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 9158057486247968214L;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "cause_id")
    protected Cause cause;

    @Column(name = "value", length = 1024)
    protected String value;

    public void setCause(Cause cause) {
        this.cause = cause;
    }

    public Cause getCause() {
        return cause;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }


}