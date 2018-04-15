package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "service_exec")
@Entity(name = "mildred$ServiceExec")
public class ServiceExec extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -6540936158433141656L;

    @Column(name = "pid", nullable = false, length = 32)
    protected String pid;

    @Column(name = "status", nullable = false, length = 128)
    protected String status;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "start_dt", nullable = false)
    protected Date startDt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "end_dt")
    protected Date endDt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "effective_dt")
    protected Date effectiveDt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "expiration_dt")
    protected Date expirationDt;

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getPid() {
        return pid;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setStartDt(Date startDt) {
        this.startDt = startDt;
    }

    public Date getStartDt() {
        return startDt;
    }

    public void setEndDt(Date endDt) {
        this.endDt = endDt;
    }

    public Date getEndDt() {
        return endDt;
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