package com.angrysurfer.mildred.entity.service;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;
import java.util.List;
import javax.persistence.OneToMany;
import com.angrysurfer.mildred.entity.media.Asset;
import com.haulmont.chile.core.annotations.MetaProperty;
import javax.persistence.Transient;

@DesignSupport("{'imported':true}")
@Table(name = "op_record")
@Entity(name = "mildred$OpRecord")
public class OpRecord extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -2564801988766430066L;

    @Column(name = "pid", nullable = false, length = 32)
    protected String pid;

    @Transient
    @MetaProperty(related = "assetId")
    protected Asset asset;

    @OneToMany(mappedBy = "opRecord")
    protected List<OpRecordParam> params;

    @Column(name = "operator_name", nullable = false, length = 64)
    protected String operatorName;

    @Column(name = "operation_name", nullable = false, length = 64)
    protected String operationName;

    @Column(name = "asset_id", nullable = false, length = 64)
    protected String assetId;

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

    public void setAsset(Asset asset) {
        this.asset = asset;
    }

    public Asset getAsset() {
        return asset;
    }


    public void setParams(List<OpRecordParam> params) {
        this.params = params;
    }

    public List<OpRecordParam> getParams() {
        return params;
    }


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

    public void setAssetId(String assetId) {
        this.assetId = assetId;
    }

    public String getAssetId() {
        return assetId;
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