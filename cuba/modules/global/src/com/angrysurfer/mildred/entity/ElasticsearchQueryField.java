package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|fieldName")
@Table(name = "doc_query_field")
@Entity(name = "mildred$DocQueryField")
public class ElasticsearchQueryField extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 462620973612172195L;

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

    @Column(name = "query_section")
    protected String querySection;

    @Column(name = "default_value", length = 128)
    protected String defaultValue;

    @JoinTable(name = "doc_query_field_jn",
        joinColumns = @JoinColumn(name = "doc_query_field_id"),
        inverseJoinColumns = @JoinColumn(name = "doc_query_id"))
    @ManyToMany
    protected List<ElasticsearchQuery> docQuery;

    public ElasticsearchQuerySection getQuerySection() {
        return querySection == null ? null : ElasticsearchQuerySection.fromId(querySection);
    }

    public void setQuerySection(ElasticsearchQuerySection querySection) {
        this.querySection = querySection == null ? null : querySection.getId();
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

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }

    public String getDefaultValue() {
        return defaultValue;
    }

    public void setDocQuery(List<ElasticsearchQuery> docQuery) {
        this.docQuery = docQuery;
    }

    public List<ElasticsearchQuery> getDocQuery() {
        return docQuery;
    }


}