class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v2.9.0.tar.gz"
  sha256 "bd3a78b92042f9104dab9c996eba5a89974bd567fe64da9a16c4739e0bf70e78"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c4a19588accf78643b55bcf22c6b8047949e30af503ae7899eb72db94fa1ab3" => :big_sur
    sha256 "ddf64aa07d7cc4368fd45a22525b634a4ecf5c22e148a4a4348fb4fe392fbe51" => :arm64_big_sur
    sha256 "b358b640e2f101925b5a9d3973de242996896b1e3346c7c75cd57121ac224f7b" => :catalina
    sha256 "81b8df9f542f00ad7da3f73273202d459185447a50cd0d4b8764805ebd059a07" => :mojave
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
