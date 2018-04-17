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

@DesignSupport("{'imported':true,'unmappedColumns':['reason_id']}")
@Table(name = "generated_reason")
@Entity(name = "mildred$GeneratedReason")
public class GeneratedReason extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -3300036190468013621L;

    @JoinTable(name = "generated_action_reason",
        joinColumns = @JoinColumn(name = "reason_id"),
        inverseJoinColumns = @JoinColumn(name = "action_id"))
    @ManyToMany
    protected List<GeneratedAction> generatedAction;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    protected GeneratedReason parent;

    public void setGeneratedAction(List<GeneratedAction> generatedAction) {
        this.generatedAction = generatedAction;
    }

    public List<GeneratedAction> getGeneratedAction() {
        return generatedAction;
    }

    public void setParent(GeneratedReason parent) {
        this.parent = parent;
    }

    public GeneratedReason getParent() {
        return parent;
    }


}