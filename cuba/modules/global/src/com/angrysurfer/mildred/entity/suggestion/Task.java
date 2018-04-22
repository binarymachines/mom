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
import com.angrysurfer.mildred.entity.analysis.Action;
import com.angrysurfer.mildred.entity.analysis.ActionStatus;
import com.angrysurfer.mildred.entity.media.Asset;
import com.haulmont.chile.core.annotations.MetaProperty;
import com.haulmont.cuba.core.entity.annotation.SystemLevel;
import javax.persistence.Column;
import javax.persistence.Lob;
import javax.persistence.Transient;
import com.haulmont.chile.core.annotations.Composition;
import javax.persistence.OneToMany;

@DesignSupport("{'imported':true,'unmappedColumns':['action_id','task_status_id','asset_id']}")
@Table(name = "task")
@Entity(name = "mildred$Task")
public class Task extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -1433374884421146661L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    protected Task parent;

    @Composition
    @OneToMany(mappedBy = "task")
    protected List<TaskParam> params;

    @Transient
    @MetaProperty(related = "assetId")
    protected Asset asset;

    @Transient
    @MetaProperty(related = "statusId")
    protected ActionStatus status;

    @Transient
    @MetaProperty(related = "actionId")
    protected Action action;

    @JoinTable(name = "task_cause_jn",
        joinColumns = @JoinColumn(name = "task_id"),
        inverseJoinColumns = @JoinColumn(name = "cause_id"))
    @ManyToMany
    protected List<Cause> cause;

    @SystemLevel
    @Lob
    @Column(name = "ASSET_ID")
    protected String assetId;

    @SystemLevel
    @Column(name = "ACTION_ID")
    protected Integer actionId;

    @SystemLevel
    @Column(name = "TASK_STATUS_ID")
    protected Integer statusId;

    public void setParams(List<TaskParam> params) {
        this.params = params;
    }

    public List<TaskParam> getParams() {
        return params;
    }


    public void setAsset(Asset asset) {
        this.asset = asset;
    }

    public Asset getAsset() {
        return asset;
    }

    public void setStatus(ActionStatus status) {
        this.status = status;
    }

    public ActionStatus getStatus() {
        return status;
    }

    public void setAction(Action action) {
        this.action = action;
    }

    public Action getAction() {
        return action;
    }

    public void setAssetId(String assetId) {
        this.assetId = assetId;
    }

    public String getAssetId() {
        return assetId;
    }

    public void setActionId(Integer actionId) {
        this.actionId = actionId;
    }

    public Integer getActionId() {
        return actionId;
    }

    public void setStatusId(Integer statusId) {
        this.statusId = statusId;
    }

    public Integer getStatusId() {
        return statusId;
    }


    public void setParent(Task parent) {
        this.parent = parent;
    }

    public Task getParent() {
        return parent;
    }

    public void setCause(List<Cause> cause) {
        this.cause = cause;
    }

    public List<Cause> getCause() {
        return cause;
    }


}