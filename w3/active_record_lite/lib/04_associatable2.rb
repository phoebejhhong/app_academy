require_relative '03_associatable'

module Associatable
  def has_one_through(name, through_name, source_name)
    through_options = self.assoc_options[through_name]

    define_method(name) do
      source_options =
        through_options.model_class.assoc_options[source_name]

      results = DBConnection.execute(<<-SQL)
        SELECT
          #{source_options.table_name}.*
        FROM
          #{through_options.table_name}
        JOIN
          #{source_options.table_name}
          ON #{source_options.table_name}.#{source_options.primary_key} = #{through_options.table_name}.#{source_options.foreign_key}
        WHERE
          #{through_options.table_name}.#{source_options.primary_key}
            = #{self.send(through_options.foreign_key)}
        SQL

        results.map { |result| source_options.model_class.new(result) }.first
    end
  end
end
