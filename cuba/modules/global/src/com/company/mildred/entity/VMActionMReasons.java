package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import com.company.mildred.entity.key.VMActionMReasonsCompKey;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import com.haulmont.cuba.core.entity.BaseGenericIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "v_m_action_m_reasons")
@Entity(name = "mildred$VMActionMReasons")
public class VMActionMReasons extends BaseGenericIdEntity<VMActionMReasonsCompKey> {
    private static final long serialVersionUID = 8219964399774161838L;

    @Column(name = "action_priority", nullable = false)
    protected Integer actionPriority;

    @Column(name = "action_dispatch_name", nullable = false, length = 128)
    protected String actionDispatchName;

    @Column(name = "action_dispatch_category", length = 128)
    protected String actionDispatchCategory;

    @Column(name = "action_dispatch_module", nullable = false, length = 128)
    protected String actionDispatchModule;

    @Column(name = "action_dispatch_class", length = 128)
    protected String actionDispatchClass;

    @Column(name = "action_dispatch_func", nullable = false, length = 128)
    protected String actionDispatchFunc;

    @Column(name = "reason_weight", nullable = false)
    protected Integer reasonWeight;

    @Column(name = "conditional_dispatch_name", nullable = false, length = 128)
    protected String conditionalDispatchName;

    @Column(name = "conditional_dispatch_category", length = 128)
    protected String conditionalDispatchCategory;

    @Column(name = "conditional_dispatch_module", nullable = false, length = 128)
    protected String conditionalDispatchModule;

    @Column(name = "conditional_dispatch_class", length = 128)
    protected String conditionalDispatchClass;

    @Column(name = "conditional_dispatch_func", nullable = false, length = 128)
    protected String conditionalDispatchFunc;

    @EmbeddedId
    protected VMActionMReasonsCompKey id;

    public void setActionPriority(Integer actionPriority) {
        this.actionPriority = actionPriority;
    }

    public Integer getActionPriority() {
        return actionPriority;
    }

    public void setActionDispatchName(String actionDispatchName) {
        this.actionDispatchName = actionDispatchName;
    }

    public String getActionDispatchName() {
        return actionDispatchName;
    }

    public void setActionDispatchCategory(String actionDispatchCategory) {
        this.actionDispatchCategory = actionDispatchCategory;
    }

    public String getActionDispatchCategory() {
        return actionDispatchCategory;
    }

    public void setActionDispatchModule(String actionDispatchModule) {
        this.actionDispatchModule = actionDispatchModule;
    }

    public String getActionDispatchModule() {
        return actionDispatchModule;
    }

    public void setActionDispatchClass(String actionDispatchClass) {
        this.actionDispatchClass = actionDispatchClass;
    }

    public String getActionDispatchClass() {
        return actionDispatchClass;
    }

    public void setActionDispatchFunc(String actionDispatchFunc) {
        this.actionDispatchFunc = actionDispatchFunc;
    }

    public String getActionDispatchFunc() {
        return actionDispatchFunc;
    }

    public void setReasonWeight(Integer reasonWeight) {
        this.reasonWeight = reasonWeight;
    }

    public Integer getReasonWeight() {
        return reasonWeight;
    }

    public void setConditionalDispatchName(String conditionalDispatchName) {
        this.conditionalDispatchName = conditionalDispatchName;
    }

    public String getConditionalDispatchName() {
        return conditionalDispatchName;
    }

    public void setConditionalDispatchCategory(String conditionalDispatchCategory) {
        this.conditionalDispatchCategory = conditionalDispatchCategory;
    }

    public String getConditionalDispatchCategory() {
        return conditionalDispatchCategory;
    }

    public void setConditionalDispatchModule(String conditionalDispatchModule) {
        this.conditionalDispatchModule = conditionalDispatchModule;
    }

    public String getConditionalDispatchModule() {
        return conditionalDispatchModule;
    }

    public void setConditionalDispatchClass(String conditionalDispatchClass) {
        this.conditionalDispatchClass = conditionalDispatchClass;
    }

    public String getConditionalDispatchClass() {
        return conditionalDispatchClass;
    }

    public void setConditionalDispatchFunc(String conditionalDispatchFunc) {
        this.conditionalDispatchFunc = conditionalDispatchFunc;
    }

    public String getConditionalDispatchFunc() {
        return conditionalDispatchFunc;
    }

    @Override
    public VMActionMReasonsCompKey getId() {
        return id;
    }

    @Override
    public void setId(VMActionMReasonsCompKey id) {
        this.id = id;
    }


}