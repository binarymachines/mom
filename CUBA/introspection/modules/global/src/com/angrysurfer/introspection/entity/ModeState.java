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

@DesignSupport("{'imported':true}")
@Table(name = "INTROSPECTION_MODE_STATE")
@Entity(name = "introspection$ModeState")
public class ModeState extends BaseUuidEntity implements Versioned, SoftDelete, Updatable, Creatable {
    private static final long serialVersionUID = 8649313734701127697L;

    @Column(name = "PID", length = 32)
    protected String pid;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "MODE_ID")
    protected Mode mode;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "STATE_ID")
    protected State state;

    @Column(name = "TIMES_ACTIVATED")
    protected Integer timesActivated;

    @Column(name = "TIMES_COMPLETED")
    protected Integer timesCompleted;

    @Column(name = "ERROR_COUNT")
    protected Integer errorCount;

    @Column(name = "CUM_ERROR_COUNT")
    protected String cumErrorCount;

    @Column(name = "STATUS")
    protected String status;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "LAST_ACTIVATED")
    protected Date lastActivated;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "LAST_ACTIVE")
    protected Date lastActive;

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


    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getPid() {
        return pid;
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

    public void setTimesActivated(Integer timesActivated) {
        this.timesActivated = timesActivated;
    }

    public Integer getTimesActivated() {
        return timesActivated;
    }

    public void setTimesCompleted(Integer timesCompleted) {
        this.timesCompleted = timesCompleted;
    }

    public Integer getTimesCompleted() {
        return timesCompleted;
    }

    public void setErrorCount(Integer errorCount) {
        this.errorCount = errorCount;
    }

    public Integer getErrorCount() {
        return errorCount;
    }

    public void setCumErrorCount(String cumErrorCount) {
        this.cumErrorCount = cumErrorCount;
    }

    public String getCumErrorCount() {
        return cumErrorCount;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setLastActivated(Date lastActivated) {
        this.lastActivated = lastActivated;
    }

    public Date getLastActivated() {
        return lastActivated;
    }

    public void setLastActive(Date lastActive) {
        this.lastActive = lastActive;
    }

    public Date getLastActive() {
        return lastActive;
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