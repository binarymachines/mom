package com.angrysurfer.mildred.entity.service;

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
@Table(name = "op_record_param")
@Entity(name = "mildred$OpRecordParam")
public class OpRecordParam extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -4699757920674461909L;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "param_type_id")
    protected OpRecordParamType paramType;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "op_record_id")
    protected OpRecord opRecord;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @Column(name = "value", nullable = false, length = 1024)
    protected String value;

    public void setParamType(OpRecordParamType paramType) {
        this.paramType = paramType;
    }

    public OpRecordParamType getParamType() {
        return paramType;
    }

    public void setOpRecord(OpRecord opRecord) {
        this.opRecord = opRecord;
    }

    public OpRecord getOpRecord() {
        return opRecord;
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