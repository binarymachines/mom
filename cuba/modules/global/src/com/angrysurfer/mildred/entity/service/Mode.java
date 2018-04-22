package com.angrysurfer.mildred.entity.service;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;
import java.util.List;
import javax.persistence.OneToMany;
import com.haulmont.chile.core.annotations.Composition;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "mode")
@Entity(name = "mildred$Mode")
public class Mode extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 5434325976931927183L;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @Column(name = "stateful_flag", nullable = false)
    protected Boolean statefulFlag = false;

    @Composition
    @OneToMany(mappedBy = "mode")
    protected List<ModeDefault> defaults;

    @Composition
    @OneToMany(mappedBy = "mode")
    protected List<ModeStateDefault> stateDefaults;

    @Composition
    @OneToMany(mappedBy = "mode")
    protected List<TransitionRule> transitionRules;

    public void setTransitionRules(List<TransitionRule> transitionRules) {
        this.transitionRules = transitionRules;
    }

    public List<TransitionRule> getTransitionRules() {
        return transitionRules;
    }


    public void setDefaults(List<ModeDefault> defaults) {
        this.defaults = defaults;
    }

    public List<ModeDefault> getDefaults() {
        return defaults;
    }

    public void setStateDefaults(List<ModeStateDefault> stateDefaults) {
        this.stateDefaults = stateDefaults;
    }

    public List<ModeStateDefault> getStateDefaults() {
        return stateDefaults;
    }


    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setStatefulFlag(Boolean statefulFlag) {
        this.statefulFlag = statefulFlag;
    }

    public Boolean getStatefulFlag() {
        return statefulFlag;
    }


}