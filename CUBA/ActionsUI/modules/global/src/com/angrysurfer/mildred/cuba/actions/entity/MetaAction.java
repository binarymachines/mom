package com.angrysurfer.mildred.cuba.actions.entity;

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
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s %s %s %s %s|name,dispatch,metaReason,vectorParam,documentType")
@Table(name = "meta_action")
@Entity(name = "actions$MetaAction")
public class MetaAction extends BaseIdentityIdEntity {
    private static final long serialVersionUID = 3619980187444969204L;

    @Column(name = "document_type", nullable = false)
    protected String documentType;

    @JoinTable(name = "m_action_m_reason",
        joinColumns = @JoinColumn(name = "meta_action_id"),
        inverseJoinColumns = @JoinColumn(name = "meta_reason_id"))
    @ManyToMany
    protected List<MetaReason> metaReason;

    @Column(name = "name", nullable = false)
    protected String name;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "dispatch_id")
    protected ActionDispatch dispatch;

    @Column(name = "priority", nullable = false)
    protected Integer priority;

    @JoinTable(name = "meta_action_param",
        joinColumns = @JoinColumn(name = "meta_action_id"),
        inverseJoinColumns = @JoinColumn(name = "vector_param_id"))
    @ManyToMany
    protected List<VectorParam> vectorParam;

    public DocumentTypeEnum getDocumentType() {
        return documentType == null ? null : DocumentTypeEnum.fromId(documentType);
    }

    public void setDocumentType(DocumentTypeEnum documentType) {
        this.documentType = documentType == null ? null : documentType.getId();
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

    public void setVectorParam(List<VectorParam> vectorParam) {
        this.vectorParam = vectorParam;
    }

    public List<VectorParam> getVectorParam() {
        return vectorParam;
    }


}