package com.angrysurfer.mildred.entity.analysis;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "action")
@Entity(name = "mildred$Action")
public class Action extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 6951658757252549270L;

    @Column(name = "name", nullable = false)
    protected String name;

    @Column(name = "asset_type", nullable = false, length = 32)
    protected String assetType;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "dispatch_id")
    protected Dispatch dispatch;

    @Column(name = "priority", nullable = false)
    protected Integer priority;

    @JoinTable(name = "action_reason",
        joinColumns = @JoinColumn(name = "action_id"),
        inverseJoinColumns = @JoinColumn(name = "reason_id"))
    @ManyToMany
    protected List<Reason> reason;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setAssetType(String assetType) {
        this.assetType = assetType;
    }

    public String getAssetType() {
        return assetType;
    }

    public void setDispatch(Dispatch dispatch) {
        this.dispatch = dispatch;
    }

    public Dispatch getDispatch() {
        return dispatch;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public Integer getPriority() {
        return priority;
    }

    public void setReason(List<Reason> reason) {
        this.reason = reason;
    }

    public List<Reason> getReason() {
        return reason;
    }


}