package com.angrysurfer.mildred.entity;

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
import com.haulmont.chile.core.annotations.MetaProperty;
import com.haulmont.cuba.core.entity.annotation.SystemLevel;
import javax.persistence.Transient;

@DesignSupport("{'imported':true,'unmappedColumns':['doc_query_id']}")
@NamePattern("%s|name")
@Table(name = "reason")
@Entity(name = "mildred$Reason")
public class Reason extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -5334542779090445441L;

    @JoinTable(name = "action_reason",
        joinColumns = @JoinColumn(name = "reason_id"),
        inverseJoinColumns = @JoinColumn(name = "action_id"))
    @ManyToMany
    protected List<Action> action;

    @Transient
    @MetaProperty(related = "docQueryId")
    protected DocQuery docQuery;

    @Column(name = "name", nullable = false)
    protected String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_reason_id")
    protected Reason parentReason;

    @Column(name = "document_type", nullable = false, length = 32)
    protected String documentType;

    @Column(name = "weight", nullable = false)
    protected Integer weight;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dispatch_id")
    protected ActionDispatch dispatch;

    @Column(name = "expected_result", nullable = false)
    protected Boolean expectedResult = false;

    @SystemLevel
    @Column(name = "DOC_QUERY_ID")
    protected Integer docQueryId;

    public void setDocQuery(DocQuery docQuery) {
        this.docQuery = docQuery;
    }

    public DocQuery getDocQuery() {
        return docQuery;
    }

    public void setDocQueryId(Integer docQueryId) {
        this.docQueryId = docQueryId;
    }

    public Integer getDocQueryId() {
        return docQueryId;
    }


    public void setAction(List<Action> action) {
        this.action = action;
    }

    public List<Action> getAction() {
        return action;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setParentReason(Reason parentReason) {
        this.parentReason = parentReason;
    }

    public Reason getParentReason() {
        return parentReason;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public String getDocumentType() {
        return documentType;
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


}