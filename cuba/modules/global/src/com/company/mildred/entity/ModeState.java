package com.company.mildred.entity;

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
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "mode_state")
@Entity(name = "mildred$ModeState")
public class ModeState extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -6818560828055145266L;

    @Column(name = "pid", nullable = false, length = 32)
    protected String pid;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "mode_id")
    protected Mode mode;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "state_id")
    protected State state;

    @Column(name = "times_activated", nullable = false)
    protected Integer timesActivated;

    @Column(name = "times_completed", nullable = false)
    protected Integer timesCompleted;

    @Column(name = "error_count", nullable = false)
    protected Integer errorCount;

    @Column(name = "cum_error_count", nullable = false)
    protected Integer cumErrorCount;

    @Column(name = "status", nullable = false, length = 64)
    protected String status;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "last_activated")
    protected Date lastActivated;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "last_completed")
    protected Date lastCompleted;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "effective_dt")
    protected Date effectiveDt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "expiration_dt", nullable = false)
    protected Date expirationDt;

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

    public void setCumErrorCount(Integer cumErrorCount) {
        this.cumErrorCount = cumErrorCount;
    }

    public Integer getCumErrorCount() {
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

    public void setLastCompleted(Date lastCompleted) {
        this.lastCompleted = lastCompleted;
    }

    public Date getLastCompleted() {
        return lastCompleted;
    }

    public void setEffectiveDt(Date effectiveDt) {
        this.effectiveDt = effectiveDt;
    }

    public Date getEffectiveDt() {
        return effectiveDt;
    }

    public void setExpirationDt(Date expirationDt) {
        this.expirationDt = expirationDt;
    }

    public Date getExpirationDt() {
        return expirationDt;
    }


}