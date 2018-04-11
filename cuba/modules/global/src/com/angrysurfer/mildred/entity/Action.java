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
@Table(name = "action")
@Entity(name = "mildred$Action")
public class Action extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 5683208299183028540L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "meta_action_id")
    protected MetaAction metaAction;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "action_status_id")
    protected ActionStatus actionStatus;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_action_id")
    protected Action parentAction;

    @JoinTable(name = "action_reason",
        joinColumns = @JoinColumn(name = "action_id"),
        inverseJoinColumns = @JoinColumn(name = "reason_id"))
    @ManyToMany
    protected List<Reason> reason;

    public void setMetaAction(MetaAction metaAction) {
        this.metaAction = metaAction;
    }

    public MetaAction getMetaAction() {
        return metaAction;
    }

    public void setActionStatus(ActionStatus actionStatus) {
        this.actionStatus = actionStatus;
    }

    public ActionStatus getActionStatus() {
        return actionStatus;
    }

    public void setParentAction(Action parentAction) {
        this.parentAction = parentAction;
    }

    public Action getParentAction() {
        return parentAction;
    }

    public void setReason(List<Reason> reason) {
        this.reason = reason;
    }

    public List<Reason> getReason() {
        return reason;
    }


}