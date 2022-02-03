#!/usr/bin/perl

use JSON::Parse 'parse_json';;
use Data::Dumper;
use DBI;

# Telegram BOT using Bot-API by Nicolas Gutierrez

my %BANNED;

my $token="YOUR_BOT_TOKEN";
my $SEND="sendMessage";
my $BAN="banChatMember";
my $URL="https://api.telegram.org/bot$token/";
my $scape=1;
my $cicle=5;
my $delay=6;
my $VALID=0;

while($scape){
    my $command=`curl -s -X POST -H 'Content-Type: application/json' -d '{"offset":-1,"limit":10}' https://api.telegram.org/bot$token/getUpdates`;
    my $hash = parse_json($command);
    foreach $m (@{$hash->{'result'}}){
        $VALID=validateUser($m->{'message'}->{'from'}->{'username'});
        if($m->{'message'}->{'text'} ne "" && $m->{'message'}->{'date'} > time - $delay && $VALID){
            print "Message From: ".$m->{'message'}->{'from'}->{'username'}."  Valid=$VALID\n";
#            print "Message From: ".$m->{'message'}->{'from'}->{'id'}."  Valid=$VALID\n";
#            print "        Chat: ".$m->{'message'}->{'chat'}->{'id'}."\n";
#            print "        Date: ".$m->{'message'}->{'date'}."\n";
            print "        Text: ".$m->{'message'}->{'text'}."\n";
            if($m->{'message'}->{'text'} =~ m/show/){
                my $show=$m->{'message'}->{'text'};
                $show=~s/^show //g;
                $MESSAGE="what SHOW command are you trying to run?";
                if($show =~ m/epoch/){
                    $MESSAGE="<b>Epoch time is:</b> ".time." seconds";
                }
                if($show =~ m/date|time/){
                    $MESSAGE="<b>Datetime is:</b> ".`date`;
                }
                if($show =~ m/banned/){
                    $MESSAGE="<b>Current banned users:</b>\n".PrintBanned(%BANNED)."";
                }
                my $send=`curl -s -X POST -H 'Content-Type: application/json' -d '{"parse_mode":"HTML","chat_id": "$m->{'message'}->{'chat'}->{'id'}", "text": "$MESSAGE", "disable_notification": true}' $URL$SEND`;
            }
            if($m->{'message'}->{'text'} =~ m/^hello|^Hello/){
                $MESSAGE="<b>Hello</b> $m->{'message'}->{'from'}->{'username'}\n";
                my $send=`curl -s -X POST -H 'Content-Type: application/json' -d '{"parse_mode":"HTML","chat_id": "$m->{'message'}->{'chat'}->{'id'}", "text": "$MESSAGE", "disable_notification": true}' $URL$SEND`;
            }
            if($m->{'message'}->{'text'} =~ m/^exec/){
                my $string=$m->{'message'}->{'text'};
                   $string=~ s/exec //g;
                $MESSAGE="<b>Command Result:</b>\n".`$string`;
                my $result=`echo $?`;
                if($result == 0){
                    print "Command execution success.\n";
                }
                else{
                    print "Command execution failed.\n";
                    $MESSAGE.=" Command failed|Error on command\n";
                }
                my $send=`curl -s -X POST -H 'Content-Type: application/json' -d '{"parse_mode":"HTML","chat_id": "$m->{'message'}->{'chat'}->{'id'}", "text": "$MESSAGE", "disable_notification": true}' $URL$SEND`;
            }
            if($m->{'message'}->{'text'} =~ m/kill bot/){
                $scape=0;
                $MESSAGE="<b>Ok Bye, gonna sleep...</b>";
#                print "$MESSAGE\n";
                my $send=`curl -s -X POST -H 'Content-Type: application/json' -d '{"parse_mode":"HTML","chat_id": "$m->{'message'}->{'chat'}->{'id'}", "text": "$MESSAGE", "disable_notification": true}' $URL$SEND`;
            }
#            print "------------------------------------------------------------------------------------------------------------------------------\n";
        }
        if($VALID == 0 && $m->{'message'}->{'date'} > time - $delay){
            if(!$BANNED{$m->{'message'}->{'from'}->{'username'}}){
                my $send=`curl -s -X POST -H 'Content-Type: application/json' -d '{"parse_mode":"HTML","chat_id": "$m->{'message'}->{'chat'}->{'id'}", "text": "This is a private bot, you <b>$m->{'message'}->{'from'}->{'username'}</b> are not authorized!!!", "disable_notification": true}' $URL$SEND`;
                my $COM=`curl -s -X POST -H 'Content-Type: application/json' -d '{"chat_id":$m->{'message'}->{'chat'}->{'id'}, "user_id":$m->{'message'}->{'from'}->{'id'}, "revoke_messages": true}' $URL$BAN`;
                print "User: $m->{'message'}->{'from'}->{'username'} with id=$m->{'message'}->{'from'}->{'id'} is Baned from chat\n$COM\n";
                $BANNED{$m->{'message'}->{'from'}->{'username'}}=1;
             }
             print "Current banned users:\n";
             PrintBanned(%BANNED);
             print "\n";
        }
    }
    sleep($cicle);
}

sub validateUser {
    my @users=("User1","User2");
    my $valid=0;
    foreach $item (@users) {
        if(@_[0] eq $item){
            $valid=1;
        }
    }
    return $valid;
}

sub PrintBanned {
   my (%hash) = @_;
   my $i=1;
   my $OUT="";
   foreach my $key ( keys %hash ) {
      my $value = $hash{$key};
      $OUT.= "<b>[$i]</b> - $key\n";
      $i++;
   }
   return $OUT;
}
