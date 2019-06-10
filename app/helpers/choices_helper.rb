module ChoicesHelper
  def link_to_add_alternative(form)
    alt = Alternative.new
    id = alt.object_id
    fields = form.fields_for(:alternatives, alt, child_index: id) do |f|
      render(partial: 'alternative', locals: { form: f })
    end
    link_to('Add an alternative', '#', id: 'add_alternative', data: {
      id: id, fields: fields.gsub("\n", '')
    })
  end
end
