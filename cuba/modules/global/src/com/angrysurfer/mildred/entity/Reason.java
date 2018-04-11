package com.angrysurfer.mildred.entity;

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

@DesignSupport("{'imported':true}")
@Table(name = "reason")
@Entity(name = "mildred$Reason")
public class Reason extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -1340422914127093248L;

    @JoinTable(name = "action_reason",
        joinColumns = @JoinColumn(name = "reason_id"),
        inverseJoinColumns = @JoinColumn(name = "action_id"))
    @ManyToMany
    protected List<Action> action;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "meta_reason_id")
    protected MetaReason metaReason;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_reason_id")
    protected Reason parentReason;

    public void setAction(List<Action> action) {
        this.action = action;
    }

    public List<Action> getAction() {
        return action;
    }

    public void setMetaReason(MetaReason metaReason) {
        this.metaReason = metaReason;
    }

    public MetaReason getMetaReason() {
        return metaReason;
    }

    public void setParentReason(Reason parentReason) {
        this.parentReason = parentReason;
    }

    public Reason getParentReason() {
        return parentReason;
    }


}