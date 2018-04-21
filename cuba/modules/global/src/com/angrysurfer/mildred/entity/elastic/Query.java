package com.angrysurfer.mildred.entity.elastic;

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
import com.haulmont.cuba.core.entity.annotation.Lookup;
import com.haulmont.cuba.core.entity.annotation.LookupType;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "query")
@Entity(name = "mildred$Query")
public class Query extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -7985173037357745328L;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "query_type_id")
    protected QueryType queryType;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "document_type_id")
    protected DocumentType documentType;

    @Column(name = "max_score_percentage", nullable = false)
    protected Double maxScorePercentage;

    @Column(name = "active_flag", nullable = false)
    protected Boolean activeFlag = false;

    @JoinTable(name = "query_clause_jn",
        joinColumns = @JoinColumn(name = "query_id"),
        inverseJoinColumns = @JoinColumn(name = "clause_id"))
    @ManyToMany
    protected List<Clause> clause;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setQueryType(QueryType queryType) {
        this.queryType = queryType;
    }

    public QueryType getQueryType() {
        return queryType;
    }

    public void setDocumentType(DocumentType documentType) {
        this.documentType = documentType;
    }

    public DocumentType getDocumentType() {
        return documentType;
    }

    public void setMaxScorePercentage(Double maxScorePercentage) {
        this.maxScorePercentage = maxScorePercentage;
    }

    public Double getMaxScorePercentage() {
        return maxScorePercentage;
    }

    public void setActiveFlag(Boolean activeFlag) {
        this.activeFlag = activeFlag;
    }

    public Boolean getActiveFlag() {
        return activeFlag;
    }

    public void setClause(List<Clause> clause) {
        this.clause = clause;
    }

    public List<Clause> getClause() {
        return clause;
    }


}