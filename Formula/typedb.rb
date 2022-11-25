class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.14.0/typedb-all-mac-2.14.0.zip"
  sha256 "93756fbd34ffdfb4e690060cd65dfb5b627ceaa2ce6eea2d6749c3112d4769f5"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5fbe7c18e2baad533e252701c5dd865bcc833e10f7639feff615452cd1a1a7ca"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server --help")
  end
end
