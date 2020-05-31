class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2020/sqlite-src-3320100.zip"
  version "3.32.1"
  sha256 "5ccc7dd634ab820dbcef56318279d27ee945ccaba17e70d4932e5c624a7872d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "22d2a8afb8f29e1e03055f1f342de5d4d175b24b42f120534052ba438c81f2c2" => :catalina
    sha256 "7a4f6abecc384a51ca4527c832d74aba5be5974dd39d195967ff4e68c4f8446f" => :mojave
    sha256 "db3d3f4efaf6158e23c983f5fe2330f8873fd50d821d536b8a568624b9021a95" => :high_sierra
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
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
