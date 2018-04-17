package com.angrysurfer.mildred.entity.service;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import com.angrysurfer.mildred.entity.service.key.VServiceSwitchRuleCompKey;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import com.haulmont.cuba.core.entity.BaseGenericIdEntity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.annotation.Lookup;
import com.haulmont.cuba.core.entity.annotation.LookupType;

@DesignSupport("{'imported':true}")
@Table(name = "v_service_switch_rule")
@Entity(name = "mildred$VServiceSwitchRule")
public class VServiceSwitchRule extends BaseGenericIdEntity<VServiceSwitchRuleCompKey> {
    private static final long serialVersionUID = 3346589847142436708L;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "service_profile_id")
    protected ServiceProfile serviceProfile;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "startup_dispatch_id")
    protected ServiceDispatch startupDispatch;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "mode_id")
    protected Mode mode;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "switch_rule_id")
    protected SwitchRule switchRule;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "before_dispatch_id")
    protected ServiceDispatch beforeDispatch;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "after_dispatch_id")
    protected ServiceDispatch afterDispatch;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "begin_mode_id")
    protected Mode beginMode;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "end_mode_id")
    protected Mode endMode;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "condition_dispatch_id")
    protected ServiceDispatch conditionDispatch;

    @EmbeddedId
    protected VServiceSwitchRuleCompKey id;

    public ServiceProfile getServiceProfile() {
        return serviceProfile;
    }

    public void setServiceProfile(ServiceProfile serviceProfile) {
        this.serviceProfile = serviceProfile;
    }


    public ServiceDispatch getStartupDispatch() {
        return startupDispatch;
    }

    public void setStartupDispatch(ServiceDispatch startupDispatch) {
        this.startupDispatch = startupDispatch;
    }


    public Mode getMode() {
        return mode;
    }

    public void setMode(Mode mode) {
        this.mode = mode;
    }


    public SwitchRule getSwitchRule() {
        return switchRule;
    }

    public void setSwitchRule(SwitchRule switchRule) {
        this.switchRule = switchRule;
    }


    public ServiceDispatch getBeforeDispatch() {
        return beforeDispatch;
    }

    public void setBeforeDispatch(ServiceDispatch beforeDispatch) {
        this.beforeDispatch = beforeDispatch;
    }


    public ServiceDispatch getAfterDispatch() {
        return afterDispatch;
    }

    public void setAfterDispatch(ServiceDispatch afterDispatch) {
        this.afterDispatch = afterDispatch;
    }


    public Mode getBeginMode() {
        return beginMode;
    }

    public void setBeginMode(Mode beginMode) {
        this.beginMode = beginMode;
    }


    public Mode getEndMode() {
        return endMode;
    }

    public void setEndMode(Mode endMode) {
        this.endMode = endMode;
    }


    public ServiceDispatch getConditionDispatch() {
        return conditionDispatch;
    }

    public void setConditionDispatch(ServiceDispatch conditionDispatch) {
        this.conditionDispatch = conditionDispatch;
    }


    @Override
    public VServiceSwitchRuleCompKey getId() {
        return id;
    }

    @Override
    public void setId(VServiceSwitchRuleCompKey id) {
        this.id = id;
    }


}