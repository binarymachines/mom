package com.angrysurfer.mildred.cuba.actions.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "vector_param")
@Entity(name = "actions$VectorParam")
public class VectorParam extends BaseIdentityIdEntity {
    private static final long serialVersionUID = -6684796027016371953L;

    @JoinTable(name = "meta_action_param",
        joinColumns = @JoinColumn(name = "vector_param_id"),
        inverseJoinColumns = @JoinColumn(name = "meta_action_id"))
    @ManyToMany
    protected List<MetaAction> metaAction;

    @JoinTable(name = "meta_reason_param",
        joinColumns = @JoinColumn(name = "vector_param_id"),
        inverseJoinColumns = @JoinColumn(name = "meta_reason_id"))
    @ManyToMany
    protected List<MetaReason> metaReason;

    @Column(name = "name", nullable = false, unique = true, length = 128)
    protected String name;

    public void setMetaAction(List<MetaAction> metaAction) {
        this.metaAction = metaAction;
    }

    public List<MetaAction> getMetaAction() {
        return metaAction;
    }

    public void setMetaReason(List<MetaReason> metaReason) {
        this.metaReason = metaReason;
    }

    public List<MetaReason> getMetaReason() {
        return metaReason;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }


}