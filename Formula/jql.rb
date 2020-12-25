class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v2.8.3.tar.gz"
  sha256 "fed30927031adaf4f51b78530cd811001c5dde3fe60fc3fcac4e16aef2589b2a"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef2ef62525d88d33ca05ee66c76f742988bab7e515dd7b61a5838788eccab117" => :big_sur
    sha256 "df9bd45f44731ca4033ed42e27c65324afe68ec4d16539ae90075df3d77e03c7" => :catalina
    sha256 "6b7303e254e7dfde4619fba4df69688f003b45346d75830e64b6a3d8c875032e" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end
