<%
if (copyright) {
        println '/*'
        println " * ${copyright.replace('\n', '\n * ')}"
        println ' */'
} else {
        print ""
}
%>package ${packageName};

import ${entity.fqn};
import com.haulmont.cuba.core.entity.Entity;<%if (collectionAttributesTablesXml) {%>
import com.haulmont.cuba.gui.ComponentsHelper;<%}%>
import com.haulmont.cuba.gui.components.*;<%if (tableActions.contains("create")) {%>
import com.haulmont.cuba.gui.components.actions.CreateAction;<%}%>
import com.haulmont.cuba.gui.components.actions.EditAction;<%if (tableActions.contains("remove")) {%>
import com.haulmont.cuba.gui.components.actions.RemoveAction;<%}%>
import com.haulmont.cuba.gui.data.CollectionDatasource;
import com.haulmont.cuba.gui.data.DataSupplier;
import com.haulmont.cuba.gui.data.Datasource;

import javax.inject.Inject;<%if (tableActions.contains("remove")) {%>
import javax.inject.Named;<%}%>
import java.util.Collections;
import java.util.Map;
import java.util.UUID;<%if (entity.genericIdType == 'IdProxy') {%>
import com.haulmont.cuba.core.entity.IdProxy;
<%} else if (entity.genericIdType == 'Embedded') {%>
import ${entity.compKeyFqn};
<%}%>
<%if (classComment) {%>
${classComment}<%}%>
public class ${controllerName} extends AbstractLookup {

    /**
     * The {@link CollectionDatasource} instance that loads a list of {@link ${entity.className}} records
     * to be displayed in {@link ${controllerName}#${tableId}} on the left
     */
    @Inject
    private CollectionDatasource<${entity.className}, <%if (entity.genericIdType == 'Embedded') {%>${entity.compKeyClassName}<%} else {%>${entity.genericIdType}<%}%>> ${tableDs};

    /**
     * The {@link Datasource} instance that contains an instance of the selected entity
     * in {@link ${controllerName}#${tableDs}}
     * <p/> Containing instance is loaded in {@link CollectionDatasource#addItemChangeListener}
     * with the view, specified in the XML screen descriptor.
     * The listener is set in the {@link ${controllerName}#init(Map)} method
     */
    @Inject
    private Datasource<${entity.className}> ${editDs};

    /**
     * The {@link Table} instance, containing a list of {@link ${entity.className}} records,
     * loaded via {@link ${controllerName}#${tableDs}}
     */
    @Inject
    private Table<${entity.className}> ${tableId};

    /**
     * The {@link BoxLayout} instance that contains components on the left side
     * of {@link SplitPanel}
     */
    @Inject
    private BoxLayout lookupBox;

    /**
     * The {@link BoxLayout} instance that contains buttons to invoke Save or Cancel actions in edit mode
     */
    @Inject
    private BoxLayout actionsPane;

    /**
     * The {@link FieldGroup} instance that is linked to {@link ${controllerName}#${editDs}}
     * and shows fields of the selected {@link ${entity.className}} record
     */
    @Inject
    private FieldGroup fieldGroup;
<%if (collectionAttributesTablesXml) {%>
    /**
     * The {@link TabSheet} instance, located on the right side of {@link SplitPanel}
     * <p/> First tab contains {@link ${controllerName}#fieldGroup}. Others tabs are designed to manipulate with
     * one-two-many related collections
     */
    @Inject
    private TabSheet tabSheet;
<%}%><%if (tableActions.contains("remove")) {%>
    /**
     * The {@link RemoveAction} instance, related to {@link ${controllerName}#${tableId}}
     */
    @Named("${tableId}.remove")
    private RemoveAction ${tableId}Remove;
<%}%>
    @Inject
    private DataSupplier dataSupplier;

    /**
     * {@link Boolean} value, indicating if a new instance of {@link ${entity.className}} is being created
     */
    private boolean creating;

    @Override
    public void init(Map<String, Object> params) {

        /*
         * Adding {@link com.haulmont.cuba.gui.data.Datasource.ItemChangeListener} to {@link ${tableDs}}
         * The listener reloads the selected record with the specified view and sets it to {@link ${editDs}}
         */
        ${tableDs}.addItemChangeListener(e -> {
            if (e.getItem() != null) {
                ${entity.className} reloadedItem = dataSupplier.reload(e.getDs().getItem(), ${editDs}.getView());
                ${editDs}.setItem(reloadedItem);
            }
        });
<%if (tableActions.contains("create")) {%>
        /*
         * Adding {@link CreateAction} to {@link ${tableId}}
         * The listener removes selection in {@link ${tableId}}, sets a newly created item to {@link ${editDs}}
         * and enables controls for record editing
         */
        ${tableId}.addAction(new CreateAction(${tableId}) {
            @Override
            protected void internalOpenEditor(CollectionDatasource datasource, Entity newItem, Datasource parentDs, Map<String, Object> params) {
                ${tableId}.setSelected(Collections.emptyList());
                ${editDs}.setItem((${entity.className}) newItem);
                refreshOptionsForLookupFields();
                enableEditControls(true);
            }
        });<%}%>

        /*
         * Adding {@link EditAction} to {@link ${tableId}}
         * The listener enables controls for record editing
         */
        ${tableId}.addAction(new EditAction(${tableId}) {
            @Override
            protected void internalOpenEditor(CollectionDatasource datasource, Entity existingItem, Datasource parentDs, Map<String, Object> params) {
                if (${tableId}.getSelected().size() == 1) {
                    refreshOptionsForLookupFields();
                    enableEditControls(false);
                }
            }
        });
<%if (tableActions.contains("remove")) {%>
        /*
         * Setting {@link RemoveAction#afterRemoveHandler} for {@link ${tableId}Remove}
         * to reset record, contained in {@link ${editDs}}
         */
        ${tableId}Remove.setAfterRemoveHandler(removedItems -> ${editDs}.setItem(null));
<%}%>
        disableEditControls();
    }

    private void refreshOptionsForLookupFields() {
        for (Component component : fieldGroup.getOwnComponents()) {
            if (component instanceof LookupField) {
                CollectionDatasource optionsDatasource = ((LookupField) component).getOptionsDatasource();
                if (optionsDatasource != null) {
                    optionsDatasource.refresh();
                }
            }
        }
    }

    /**
     * Method that is invoked by clicking Ok button after editing an existing or creating a new record
     */
    public void save() {
        if (!validate(Collections.singletonList(fieldGroup))) {
            return;
        }
        getDsContext().commit();

        ${entity.className} editedItem = ${editDs}.getItem();
        if (creating) {
            ${tableDs}.includeItem(editedItem);
        } else {
            ${tableDs}.updateItem(editedItem);
        }
        ${tableId}.setSelected(editedItem);

        disableEditControls();
    }

    /**
     * Method that is invoked by clicking Cancel button, discards changes and disables controls for record editing
     */
    public void cancel() {
        ${entity.className} selectedItem = ${tableDs}.getItem();
        if (selectedItem != null) {
            ${entity.className} reloadedItem = dataSupplier.reload(selectedItem, ${editDs}.getView());
            ${tableDs}.setItem(reloadedItem);
        } else {
            ${editDs}.setItem(null);
        }

        disableEditControls();
    }

    /**
     * Enabling controls for record editing
     * @param creating indicates if a new instance of {@link ${entity.className}} is being created
     */
    private void enableEditControls(boolean creating) {
        this.creating = creating;
        initEditComponents(true);
        fieldGroup.requestFocus();
    }

    /**
     * Disabling editing controls
     */
    private void disableEditControls() {
        initEditComponents(false);
        ${tableId}.requestFocus();
    }

    /**
     * Initiating edit controls, depending on if they should be enabled/disabled
     * @param enabled if true - enables editing controls and disables controls on the left side of the splitter
     *                if false - visa versa
     */
    private void initEditComponents(boolean enabled) {
        <%if (collectionAttributesTablesXml) {%>ComponentsHelper.walkComponents(tabSheet, (component, name) -> {
            if (component instanceof FieldGroup) {
                ((FieldGroup) component).setEditable(enabled);
            } else if (component instanceof Table) {
                ((Table) component).getActions().forEach(action -> action.setEnabled(enabled));
            }
        });<%} else {%>fieldGroup.setEditable(enabled);<%}%>
        actionsPane.setVisible(enabled);
        lookupBox.setEnabled(!enabled);
    }
}