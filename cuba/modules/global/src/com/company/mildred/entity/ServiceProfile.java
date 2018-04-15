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
@Table(name = "service_profile")
@Entity(name = "mildred$ServiceProfile")
public class ServiceProfile extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 8261923566667983127L;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "startup_service_dispatch_id")
    protected ServiceDispatch startupServiceDispatch;

    @Column(name = "name", length = 128)
    protected String name;

    @JoinTable(name = "service_profile_switch_rule_jn",
        joinColumns = @JoinColumn(name = "service_profile_id"),
        inverseJoinColumns = @JoinColumn(name = "switch_rule_id"))
    @ManyToMany
    protected List<SwitchRule> switchRule;

    public void setStartupServiceDispatch(ServiceDispatch startupServiceDispatch) {
        this.startupServiceDispatch = startupServiceDispatch;
    }

    public ServiceDispatch getStartupServiceDispatch() {
        return startupServiceDispatch;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setSwitchRule(List<SwitchRule> switchRule) {
        this.switchRule = switchRule;
    }

    public List<SwitchRule> getSwitchRule() {
        return switchRule;
    }


}