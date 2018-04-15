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
@Table(name = "transition_rule")
@Entity(name = "mildred$TransitionRule")
public class TransitionRule extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 1173582074798187391L;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "mode_id")
    protected Mode mode;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "begin_state_id")
    protected State beginState;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "end_state_id")
    protected State endState;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "condition_dispatch_id")
    protected ServiceDispatch conditionDispatch;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setMode(Mode mode) {
        this.mode = mode;
    }

    public Mode getMode() {
        return mode;
    }

    public void setBeginState(State beginState) {
        this.beginState = beginState;
    }

    public State getBeginState() {
        return beginState;
    }

    public void setEndState(State endState) {
        this.endState = endState;
    }

    public State getEndState() {
        return endState;
    }

    public void setConditionDispatch(ServiceDispatch conditionDispatch) {
        this.conditionDispatch = conditionDispatch;
    }

    public ServiceDispatch getConditionDispatch() {
        return conditionDispatch;
    }


}