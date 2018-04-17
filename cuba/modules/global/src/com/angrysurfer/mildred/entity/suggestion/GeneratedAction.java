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

@DesignSupport("{'imported':true,'unmappedColumns':['action_id','action_status_id','document_id']}")
@Table(name = "generated_action")
@Entity(name = "mildred$GeneratedAction")
public class GeneratedAction extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 2140530576878228546L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    protected GeneratedAction parent;

    @JoinTable(name = "generated_action_reason",
        joinColumns = @JoinColumn(name = "action_id"),
        inverseJoinColumns = @JoinColumn(name = "reason_id"))
    @ManyToMany
    protected List<GeneratedReason> generatedReason;

    public void setParent(GeneratedAction parent) {
        this.parent = parent;
    }

    public GeneratedAction getParent() {
        return parent;
    }

    public void setGeneratedReason(List<GeneratedReason> generatedReason) {
        this.generatedReason = generatedReason;
    }

    public List<GeneratedReason> getGeneratedReason() {
        return generatedReason;
    }


}