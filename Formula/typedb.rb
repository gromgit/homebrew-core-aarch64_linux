class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.1.2/typedb-all-mac-2.1.2.zip"
  sha256 "b420bdf20ea7db7956e36c4bc2ddf7f42f3ea4f1523363b398578da476bfd86e"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb1c1d2c30e60d3f3a4838574effa9a93dc130e175268cb3c2b6d889c931e6f3"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server status")
  end
end
