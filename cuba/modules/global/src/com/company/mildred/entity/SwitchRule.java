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
@Table(name = "switch_rule")
@Entity(name = "mildred$SwitchRule")
public class SwitchRule extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 8674233003220527213L;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "begin_mode_id")
    protected Mode beginMode;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "end_mode_id")
    protected Mode endMode;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "before_dispatch_id")
    protected ServiceDispatch beforeDispatch;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "after_dispatch_id")
    protected ServiceDispatch afterDispatch;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "condition_dispatch_id")
    protected ServiceDispatch conditionDispatch;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setBeginMode(Mode beginMode) {
        this.beginMode = beginMode;
    }

    public Mode getBeginMode() {
        return beginMode;
    }

    public void setEndMode(Mode endMode) {
        this.endMode = endMode;
    }

    public Mode getEndMode() {
        return endMode;
    }

    public void setBeforeDispatch(ServiceDispatch beforeDispatch) {
        this.beforeDispatch = beforeDispatch;
    }

    public ServiceDispatch getBeforeDispatch() {
        return beforeDispatch;
    }

    public void setAfterDispatch(ServiceDispatch afterDispatch) {
        this.afterDispatch = afterDispatch;
    }

    public ServiceDispatch getAfterDispatch() {
        return afterDispatch;
    }

    public void setConditionDispatch(ServiceDispatch conditionDispatch) {
        this.conditionDispatch = conditionDispatch;
    }

    public ServiceDispatch getConditionDispatch() {
        return conditionDispatch;
    }


}