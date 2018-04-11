package com.company.mildred.entity;

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
@Table(name = "meta_action")
@Entity(name = "mildred$MetaAction")
public class MetaAction extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -6324925398544129526L;

    @JoinTable(name = "m_action_m_reason",
        joinColumns = @JoinColumn(name = "meta_action_id"),
        inverseJoinColumns = @JoinColumn(name = "meta_reason_id"))
    @ManyToMany
    protected List<MetaReason> metaReason;

    @Column(name = "name", nullable = false)
    protected String name;

    @Column(name = "document_type", nullable = false, length = 32)
    protected String documentType;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "dispatch_id")
    protected ActionDispatch dispatch;

    @Column(name = "priority", nullable = false)
    protected Integer priority;

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

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public String getDocumentType() {
        return documentType;
    }

    public void setDispatch(ActionDispatch dispatch) {
        this.dispatch = dispatch;
    }

    public ActionDispatch getDispatch() {
        return dispatch;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public Integer getPriority() {
        return priority;
    }


}