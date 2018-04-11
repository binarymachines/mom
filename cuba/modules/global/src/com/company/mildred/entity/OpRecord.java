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
@Table(name = "op_record")
@Entity(name = "mildred$OpRecord")
public class OpRecord extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -3954144322830780705L;

    @Column(name = "pid", nullable = false, length = 32)
    protected String pid;

    @Column(name = "operator_name", nullable = false, length = 64)
    protected String operatorName;

    @Column(name = "operation_name", nullable = false, length = 64)
    protected String operationName;

    @Column(name = "target_esid", nullable = false, length = 64)
    protected String targetEsid;

    @Column(name = "target_path", nullable = false, length = 1024)
    protected String targetPath;

    @Column(name = "status", nullable = false, length = 64)
    protected String status;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "start_time", nullable = false)
    protected Date startTime;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "end_time")
    protected Date endTime;

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

    public void setOperatorName(String operatorName) {
        this.operatorName = operatorName;
    }

    public String getOperatorName() {
        return operatorName;
    }

    public void setOperationName(String operationName) {
        this.operationName = operationName;
    }

    public String getOperationName() {
        return operationName;
    }

    public void setTargetEsid(String targetEsid) {
        this.targetEsid = targetEsid;
    }

    public String getTargetEsid() {
        return targetEsid;
    }

    public void setTargetPath(String targetPath) {
        this.targetPath = targetPath;
    }

    public String getTargetPath() {
        return targetPath;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public Date getEndTime() {
        return endTime;
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