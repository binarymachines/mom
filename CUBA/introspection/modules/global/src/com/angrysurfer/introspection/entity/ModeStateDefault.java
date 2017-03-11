package com.angrysurfer.introspection.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;
import com.haulmont.cuba.core.entity.BaseUuidEntity;
import com.haulmont.cuba.core.entity.Versioned;
import com.haulmont.cuba.core.entity.SoftDelete;
import com.haulmont.cuba.core.entity.Updatable;
import com.haulmont.cuba.core.entity.Creatable;
import com.haulmont.cuba.core.entity.annotation.Lookup;
import com.haulmont.cuba.core.entity.annotation.LookupType;

@DesignSupport("{'imported':true}")
@Table(name = "INTROSPECTION_MODE_STATE_DEFAULT")
@Entity(name = "introspection$ModeStateDefault")
public class ModeStateDefault extends BaseUuidEntity implements Versioned, SoftDelete, Updatable, Creatable {
    private static final long serialVersionUID = -1555524838784358161L;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "MODE_ID")
    protected Mode mode;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "STATE_ID")
    protected State state;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "EFFECT_DISPATCH_ID")
    protected Dispatch effectDispatch;

    @Column(name = "ERROR_TOLERANCE")
    protected Integer errorTolerance;

    @Column(name = "DEC_PRIORITY_AMOUNT")
    protected Integer decPriorityAmount;

    @Column(name = "INC_PRIORITY_AMOUNT")
    protected Integer incPriorityAmount;

    @Column(name = "TIME_TO_COMPLETE")
    protected Integer timeToComplete;

    @Column(name = "PRIORITY")
    protected Integer priority;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CREATE_TS")
    protected Date createTs;

    @Column(name = "CREATED_BY", length = 50)
    protected String createdBy;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DELETE_TS")
    protected Date deleteTs;

    @Column(name = "DELETED_BY", length = 50)
    protected String deletedBy;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "UPDATE_TS")
    protected Date updateTs;

    @Column(name = "UPDATED_BY", length = 50)
    protected String updatedBy;

    @Version
    @Column(name = "VERSION", nullable = false)
    protected Integer version;

    @Override
    public Boolean isDeleted() {
        return deleteTs != null;
    }


    public void setMode(Mode mode) {
        this.mode = mode;
    }

    public Mode getMode() {
        return mode;
    }

    public void setState(State state) {
        this.state = state;
    }

    public State getState() {
        return state;
    }

    public void setEffectDispatch(Dispatch effectDispatch) {
        this.effectDispatch = effectDispatch;
    }

    public Dispatch getEffectDispatch() {
        return effectDispatch;
    }

    public void setErrorTolerance(Integer errorTolerance) {
        this.errorTolerance = errorTolerance;
    }

    public Integer getErrorTolerance() {
        return errorTolerance;
    }

    public void setDecPriorityAmount(Integer decPriorityAmount) {
        this.decPriorityAmount = decPriorityAmount;
    }

    public Integer getDecPriorityAmount() {
        return decPriorityAmount;
    }

    public void setIncPriorityAmount(Integer incPriorityAmount) {
        this.incPriorityAmount = incPriorityAmount;
    }

    public Integer getIncPriorityAmount() {
        return incPriorityAmount;
    }

    public void setTimeToComplete(Integer timeToComplete) {
        this.timeToComplete = timeToComplete;
    }

    public Integer getTimeToComplete() {
        return timeToComplete;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public Integer getPriority() {
        return priority;
    }

    @Override
    public void setCreateTs(Date createTs) {
        this.createTs = createTs;
    }

    @Override
    public Date getCreateTs() {
        return createTs;
    }

    @Override
    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public String getCreatedBy() {
        return createdBy;
    }

    @Override
    public void setDeleteTs(Date deleteTs) {
        this.deleteTs = deleteTs;
    }

    @Override
    public Date getDeleteTs() {
        return deleteTs;
    }

    @Override
    public void setDeletedBy(String deletedBy) {
        this.deletedBy = deletedBy;
    }

    @Override
    public String getDeletedBy() {
        return deletedBy;
    }

    @Override
    public void setUpdateTs(Date updateTs) {
        this.updateTs = updateTs;
    }

    @Override
    public Date getUpdateTs() {
        return updateTs;
    }

    @Override
    public void setUpdatedBy(String updatedBy) {
        this.updatedBy = updatedBy;
    }

    @Override
    public String getUpdatedBy() {
        return updatedBy;
    }

    @Override
    public void setVersion(Integer version) {
        this.version = version;
    }

    @Override
    public Integer getVersion() {
        return version;
    }


}