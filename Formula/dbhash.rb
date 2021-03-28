class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2021/sqlite-src-3350300.zip"
  version "3.35.3"
  sha256 "4ca1dff5578b1720061dd4452f91a5c3eced5ba3773354291d9aee9e2796a720"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43ad6434d731d97f7e23758655335d66129a4534e0b63b69c14a3356fb23aa5c"
    sha256 cellar: :any_skip_relocation, big_sur:       "d21cc2dfeaaf7589c64415765fc1b1f4497fc5fe20775bc9f206da6822df4557"
    sha256 cellar: :any_skip_relocation, catalina:      "c9f22cd366e4d8423451219b22ab169a67de031245da6efc089555701cfc5095"
    sha256 cellar: :any_skip_relocation, mojave:        "f722c75c491e3801a025c1fc5d2cd80a16ef5eda9691b69bac1b33a61a06a1b7"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
