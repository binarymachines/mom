package com.angrysurfer.mildred.cuba.primary.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true,'unmappedColumns':['effective_dt','expiration_dt']}")
@Table(name = "matcher_field")
@Entity(name = "primary$MatcherField")
public class MatcherField extends BaseIdentityIdEntity {
    private static final long serialVersionUID = -2208083925453592860L;

    @Column(name = "index_name", nullable = false, length = 128)
    protected String indexName;

    @Column(name = "document_type", nullable = false, length = 64)
    protected String documentType;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "matcher_id")
    protected Matcher matcher;

    @Column(name = "field_name", nullable = false, length = 128)
    protected String fieldName;

    @Column(name = "boost", nullable = false)
    protected Double boost;

    @Column(name = "bool_", length = 16)
    protected String bool;

    @Column(name = "operator", length = 16)
    protected String operator;

    @Column(name = "minimum_should_match", nullable = false)
    protected Double minimumShouldMatch;

    @Column(name = "analyzer", length = 64)
    protected String analyzer;

    @Column(name = "query_section", length = 128)
    protected String querySection;

    @Column(name = "default_value", length = 128)
    protected String defaultValue;

    public void setIndexName(String indexName) {
        this.indexName = indexName;
    }

    public String getIndexName() {
        return indexName;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public String getDocumentType() {
        return documentType;
    }

    public void setMatcher(Matcher matcher) {
        this.matcher = matcher;
    }

    public Matcher getMatcher() {
        return matcher;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setBoost(Double boost) {
        this.boost = boost;
    }

    public Double getBoost() {
        return boost;
    }

    public void setBool(String bool) {
        this.bool = bool;
    }

    public String getBool() {
        return bool;
    }

    public void setOperator(String operator) {
        this.operator = operator;
    }

    public String getOperator() {
        return operator;
    }

    public void setMinimumShouldMatch(Double minimumShouldMatch) {
        this.minimumShouldMatch = minimumShouldMatch;
    }

    public Double getMinimumShouldMatch() {
        return minimumShouldMatch;
    }

    public void setAnalyzer(String analyzer) {
        this.analyzer = analyzer;
    }

    public String getAnalyzer() {
        return analyzer;
    }

    public void setQuerySection(String querySection) {
        this.querySection = querySection;
    }

    public String getQuerySection() {
        return querySection;
    }

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }

    public String getDefaultValue() {
        return defaultValue;
    }


}