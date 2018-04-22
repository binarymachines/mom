package com.angrysurfer.mildred.entity.suggestion;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.List;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;
import com.haulmont.cuba.core.entity.annotation.Lookup;
import com.haulmont.cuba.core.entity.annotation.LookupType;
import javax.persistence.OneToMany;
import com.haulmont.chile.core.annotations.Composition;
import com.angrysurfer.mildred.entity.analysis.Reason;
import com.angrysurfer.mildred.entity.media.Asset;
import com.haulmont.chile.core.annotations.MetaProperty;
import com.haulmont.cuba.core.entity.annotation.SystemLevel;
import javax.persistence.Column;
import javax.persistence.Lob;
import javax.persistence.Transient;
import com.angrysurfer.mildred.entity.elastic.DocumentType;

@DesignSupport("{'imported':true,'unmappedColumns':['reason_id','asset_id']}")
@Table(name = "cause")
@Entity(name = "mildred$Cause")
public class Cause extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 1670221469179484512L;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    protected Cause parent;

    @Transient
    @MetaProperty(mandatory = true, related = "assetId")
    protected Asset asset;

    @Composition
    @OneToMany(mappedBy = "cause")
    protected List<CauseParam> params;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @Transient
    @MetaProperty(related = "reasonId")
    protected Reason reason;

    @JoinTable(name = "task_cause_jn",
        joinColumns = @JoinColumn(name = "cause_id"),
        inverseJoinColumns = @JoinColumn(name = "task_id"))
    @ManyToMany
    protected List<Task> task;

    @SystemLevel
    @Lob
    @Column(name = "ASSET_ID")
    protected String assetId;

    @SystemLevel
    @Column(name = "REASON_ID", nullable = false)
    protected Integer reasonId;


    public void setAsset(Asset asset) {
        this.asset = asset;
    }

    public Asset getAsset() {
        return asset;
    }

    public void setReason(Reason reason) {
        this.reason = reason;
    }

    public Reason getReason() {
        return reason;
    }

    public void setAssetId(String assetId) {
        this.assetId = assetId;
    }

    public String getAssetId() {
        return assetId;
    }

    public void setReasonId(Integer reasonId) {
        this.reasonId = reasonId;
    }

    public Integer getReasonId() {
        return reasonId;
    }


    public void setParams(List<CauseParam> params) {
        this.params = params;
    }

    public List<CauseParam> getParams() {
        return params;
    }


    public void setParent(Cause parent) {
        this.parent = parent;
    }

    public Cause getParent() {
        return parent;
    }

    public void setTask(List<Task> task) {
        this.task = task;
    }

    public List<Task> getTask() {
        return task;
    }


}