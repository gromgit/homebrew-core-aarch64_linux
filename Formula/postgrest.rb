require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/begriffs/postgrest"
  url "https://github.com/begriffs/postgrest/archive/v0.3.1.1.tar.gz"
  sha256 "1830900175879d4be40b93410a7617cb637aae7e9e70792bf70e2bf72b0b2150"
  revision 1

  bottle do
    sha256 "ba54697c96d2c860b70cd4b741903321c3888b2fb7c1da5f8e9902d19c3c45cd" => :el_capitan
    sha256 "71b5b1555385bf22a7c1a48cf5a865afd9d9a10c6336b6e31bdeb0f78009b6c8" => :yosemite
    sha256 "442ed19e6f8a0f2655113d0470af713f5bbbe2a6ec040a1eca038bea66e47324" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "postgresql"

  def install
    # GHC 8 compat
    # Reported 26 May 2016: https://github.com/begriffs/postgrest/issues/612
    cabalcfg = "allow-newer: base,transformers"
    cabalcfg << "\nconstraints:"
    cabal_sandbox do
      %w[
        bytestring-tree-builder 0.2.6
        postgresql-binary 0.9
        hasql-transaction 0.4.4.1
      ].each_slice(2) do |pkg, ver|
        cabalcfg << "\n#{pkg} ==#{ver}"
        system "cabal", "get", pkg
        cabal_sandbox_add_source "#{pkg}-#{ver}"
        inreplace "#{pkg}-#{ver}/#{pkg}.cabal" do |s|
          if pkg == "hasql-transaction"
            s.gsub! "build-depends:", "build-depends: base,"
          else
            s.gsub! "ghc-options:", "ghc-options: -XNoImpredicativeTypes"
          end
        end
      end
      (buildpath/"cabal.config").write(cabalcfg)

      install_cabal_package :using => ["happy"]
    end
  end

  test do
    pg_bin  = Formula["postgresql"].bin
    pg_port = 55561
    pg_user = "postgrest_test_user"
    test_db = "test_postgrest_formula"

    system "#{pg_bin}/initdb", "-D", testpath/test_db,
      "--auth=trust", "--username=#{pg_user}"

    system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "-l",
      testpath/"#{test_db}.log", "-w", "-o", %("-p #{pg_port}"), "start"

    begin
      system "#{pg_bin}/createdb", "-w", "-p", pg_port, "-U", pg_user, test_db
      pid = fork do
        exec "postgrest", "postgres://#{pg_user}@localhost:#{pg_port}/#{test_db}",
          "-a", pg_user, "-p", "55560"
      end
      Process.detach(pid)
      sleep(5) # Wait for the server to start
      response = Net::HTTP.get(URI("http://localhost:55560"))
      assert_equal "[]", response
    ensure
      begin
        Process.kill("TERM", pid) if pid
      ensure
        system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "stop",
          "-s", "-m", "fast"
      end
    end
  end
end
