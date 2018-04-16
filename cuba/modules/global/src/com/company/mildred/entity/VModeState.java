package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import com.company.mildred.entity.key.VModeStateCompKey;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import com.haulmont.cuba.core.entity.BaseGenericIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "v_mode_state")
@Entity(name = "mildred$VModeState")
public class VModeState extends BaseGenericIdEntity<VModeStateCompKey> {
    private static final long serialVersionUID = 2841370340874847886L;

    @Column(name = "status", nullable = false, length = 64)
    protected String status;

    @Column(name = "times_activated", nullable = false)
    protected Integer timesActivated;

    @Column(name = "times_completed", nullable = false)
    protected Integer timesCompleted;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "last_activated")
    protected Date lastActivated;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "last_completed")
    protected Date lastCompleted;

    @Column(name = "error_count", nullable = false)
    protected Integer errorCount;

    @Column(name = "cum_error_count", nullable = false)
    protected Integer cumErrorCount;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "expiration_dt", nullable = false)
    protected Date expirationDt;

    @EmbeddedId
    protected VModeStateCompKey id;

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
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

    public void setLastActivated(Date lastActivated) {
        this.lastActivated = lastActivated;
    }

    public Date getLastActivated() {
        return lastActivated;
    }

    public void setLastCompleted(Date lastCompleted) {
        this.lastCompleted = lastCompleted;
    }

    public Date getLastCompleted() {
        return lastCompleted;
    }

    public void setErrorCount(Integer errorCount) {
        this.errorCount = errorCount;
    }

    public Integer getErrorCount() {
        return errorCount;
    }

    public void setCumErrorCount(Integer cumErrorCount) {
        this.cumErrorCount = cumErrorCount;
    }

    public Integer getCumErrorCount() {
        return cumErrorCount;
    }

    public void setExpirationDt(Date expirationDt) {
        this.expirationDt = expirationDt;
    }

    public Date getExpirationDt() {
        return expirationDt;
    }

    @Override
    public VModeStateCompKey getId() {
        return id;
    }

    @Override
    public void setId(VModeStateCompKey id) {
        this.id = id;
    }


}