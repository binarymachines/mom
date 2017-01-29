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
@NamePattern("%s %s %s %s %s|name,dispatch,documentType,esSearchSpec,vectorParam")
@Table(name = "meta_reason")
@Entity(name = "actions$MetaReason")
public class MetaReason extends BaseIdentityIdEntity {
    private static final long serialVersionUID = -5821457532548542025L;

    @Column(name = "name", nullable = false)
    protected String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_meta_reason_id")
    protected MetaReason parentMetaReason;

    @Column(name = "document_type", nullable = false)
    protected String documentType;

    @Column(name = "weight", nullable = false)
    protected Integer weight;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dispatch_id")
    protected ActionDispatch dispatch;

    @Column(name = "expected_result", nullable = false)
    protected Boolean expectedResult = false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "es_search_spec_id")
    protected EsSearchSpec esSearchSpec;

    @JoinTable(name = "m_action_m_reason",
        joinColumns = @JoinColumn(name = "meta_reason_id"),
        inverseJoinColumns = @JoinColumn(name = "meta_action_id"))
    @ManyToMany
    protected List<MetaAction> metaAction;

    @JoinTable(name = "meta_reason_param",
        joinColumns = @JoinColumn(name = "meta_reason_id"),
        inverseJoinColumns = @JoinColumn(name = "vector_param_id"))
    @ManyToMany
    protected List<VectorParam> vectorParam;

    public DocumentTypeEnum getDocumentType() {
        return documentType == null ? null : DocumentTypeEnum.fromId(documentType);
    }

    public void setDocumentType(DocumentTypeEnum documentType) {
        this.documentType = documentType == null ? null : documentType.getId();
    }


    public void setMetaAction(List<MetaAction> metaAction) {
        this.metaAction = metaAction;
    }

    public List<MetaAction> getMetaAction() {
        return metaAction;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setParentMetaReason(MetaReason parentMetaReason) {
        this.parentMetaReason = parentMetaReason;
    }

    public MetaReason getParentMetaReason() {
        return parentMetaReason;
    }

    public void setWeight(Integer weight) {
        this.weight = weight;
    }

    public Integer getWeight() {
        return weight;
    }

    public void setDispatch(ActionDispatch dispatch) {
        this.dispatch = dispatch;
    }

    public ActionDispatch getDispatch() {
        return dispatch;
    }

    public void setExpectedResult(Boolean expectedResult) {
        this.expectedResult = expectedResult;
    }

    public Boolean getExpectedResult() {
        return expectedResult;
    }

    public void setEsSearchSpec(EsSearchSpec esSearchSpec) {
        this.esSearchSpec = esSearchSpec;
    }

    public EsSearchSpec getEsSearchSpec() {
        return esSearchSpec;
    }

    public void setVectorParam(List<VectorParam> vectorParam) {
        this.vectorParam = vectorParam;
    }

    public List<VectorParam> getVectorParam() {
        return vectorParam;
    }


}