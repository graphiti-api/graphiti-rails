# TODO: Write proper specs
require "rails_helper"

RSpec.describe Graphiti::Rails::Railtie do
  before do
    stub_const("::Rails", rails)
    Graphiti.instance_variable_set(:@config, nil)
  end

  after do
    Graphiti.instance_variable_set(:@config, nil)
  end

  describe "when rails is defined with logger" do
    let(:rails) do
      logger = OpenStruct.new(level: 1)
      def logger.debug?
        level == 0
      end

      double(root: Pathname.new("/foo/bar"), logger: logger)
    end

    describe "#schema_path" do
      it "defaults" do
        expect(Graphiti.config.schema_path.to_s)
          .to eq("/foo/bar/public/schema.json")
      end
    end

    describe "#debug" do
      subject { Graphiti.config.debug }

      context "when rails logger is debug level" do
        before do
          rails.logger.level = 0
        end

        it { is_expected.to eq(true) }
      end

      context "when rails logger is not debug level" do
        it { is_expected.to eq(false) }
      end
    end

    it "sets the graphiti logger to the rails logger" do
      Graphiti.config
      expect(Graphiti.logger).to eq(rails.logger)
    end
  end

  context "when Rails is defined without logger" do
    let(:rails) { stub_const("::Rails", double(root: Pathname.new("/foo/bar"), logger: nil)) }

    it "defaults" do
      expect(Graphiti.config.schema_path.to_s)
        .to eq("/foo/bar/public/schema.json")
    end
  end
end
