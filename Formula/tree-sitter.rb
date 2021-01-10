class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/0.18.0.tar.gz"
  sha256 "574458dbc8b6761027d3090bc2fd474f17ea77d875d4713ed9260d0def125bce"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "31e8ee1b74728b4720c33487d41c24d3b2e947c53f5b586c713f11159b195d8d" => :big_sur
    sha256 "bde39679171a3c3aec7c9f5fec924b106a5582977435a559c8767ab9a477a328" => :arm64_big_sur
    sha256 "31815f6cc12219253cb73ea3626383119e11f2f027286641f8dadaf69381852e" => :catalina
    sha256 "fbef61fe89cc07c5af05a06185ccb91cfa9c34773ab6b26b751ae0171e3806a2" => :mojave
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    # a trivial tree-sitter test
    assert_equal "tree-sitter #{version}", shell_output("#{bin}/tree-sitter --version").strip

    # test `tree-sitter generate`
    (testpath/"grammar.js").write <<~EOS
      module.exports = grammar({
        name: 'YOUR_LANGUAGE_NAME',
        rules: {
          source_file: $ => 'hello'
        }
      });
    EOS
    system "#{bin}/tree-sitter", "generate"

    # test `tree-sitter parse`
    (testpath/"test/corpus/hello.txt").write <<~EOS
      hello
    EOS
    parse_result = shell_output("#{bin}/tree-sitter parse #{testpath}/test/corpus/hello.txt").strip
    assert_equal("(source_file [0, 0] - [1, 0])", parse_result)

    # test `tree-sitter test`
    (testpath/"test"/"corpus"/"test_case.txt").write <<~EOS
      =========
        hello
      =========
      hello
      ---
      (source_file)
    EOS
    system "#{bin}/tree-sitter", "test"

    (testpath/"test_program.c").write <<~EOS
      #include <string.h>
      #include <tree_sitter/api.h>
      int main(int argc, char* argv[]) {
        TSParser *parser = ts_parser_new();
        if (parser == NULL) {
          return 1;
        }
        // Because we have no language libraries installed, we cannot
        // actually parse a string successfully. But, we can verify
        // that it can at least be attempted.
        const char *source_code = "empty";
        TSTree *tree = ts_parser_parse_string(
          parser,
          NULL,
          source_code,
          strlen(source_code)
        );
        if (tree == NULL) {
          printf("tree creation failed");
        }
        ts_tree_delete(tree);
        ts_parser_delete(parser);
        return 0;
      }
    EOS
    system ENV.cc, "test_program.c", "-L#{lib}", "-ltree-sitter", "-o", "test_program"
    assert_equal "tree creation failed", shell_output("./test_program")
  end
end
