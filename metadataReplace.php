<?php

	// Created 2017-12-12 by Timothy Ryan Mendenhall, Metadata Librarian, Fordham University
	// Purpose: batch replace metadata in a CONTENTdm collection based on input from a tab-delimited file
	// The script builds on the sample PHP script from the OCLC CONTENTdm Catcher documentation
	// This script only works with a single collection at a time
	// I have tested and successfully run this script using a local instance of XAMPP on a Windows desktop computer
	// If running on XAMPP, be sure to increase the max_execution_time variable in the php.ini file
	// located in the xampp/php folder of your XAMPP file to enable sufficient time for the transaction to process
	
	// Set up error notification

	ini_set('display_errors',1);
	error_reporting(E_ALL);

	// Enter in the authentication information for your CONTENTdm instance and the alias of the collection

	$CATCHERURL = "https://worldcat.org/webservices/contentdm/catcher/6.0/CatcherService.wsdl";
	$CDMURL = "http://server17265.contentdm.oclc.org:8888/";
	$CDMUSERNAME = "timothyryan50";
	$CDMPASSWORD = "MyjDHa5q";
	$CDMLICENSE = "QZNTL-8AMXD-ZRZDS-UYE55";
	
	// Enter the name of your collection in CDM here

	$CDMALIAS = "ENTER THE NAME OF YOUR COLLLECTION !!!!!!!!!!!";

	//----------------------------------------------------------------------------------------------
	//  create object to connect to Catcher web service then make calls
	//----------------------------------------------------------------------------------------------

	$catcherws = new SoapClient ($CATCHERURL);

	//load the tsv-reader function 
	// TRM: look into replacing this dependency, as it is "copyrighted" (sigh)
	// available from: https://inkplant.com/code/tsv-to-array
	// save the file to the same directory as this script, rename it to:
	// tsv-to-array-Catcher.php

	require_once 'tsv-to-array_Catcher.php';

	//tsv-reader  opens up your file and converts it to an array
	//enter the name of your TSV file here!

	$file = 'ENTER THE NAME OF YOUR FILE!!!!!';
	$data = tsv_to_array($file,array('header_row'=>true,'remove_header_row'=>true));

	//loop through tsv to create nested metadata arrays for Catcher

	foreach ($data as $records) {
		$metadataList = array();
		$key = array_keys($records);
		$totalFields = count($key);
		for ($i = 0; $i < $totalFields; $i++)
		{	
			$field = $key[$i];
			$value = $records[$field];
			$metadata = array('field' => strval($field), 'value' => strval($value));
			$metadataList[$i] = $metadata;

		}
		$metadataWrapper = array('metadataList' => $metadataList);

		// The following commented-out lines I keep in here in case I need to check the output of the metadataWrapper array, 
		// prior to running the script

		//$serializedList = var_export($metadataWrapper);
		//file_put_contents('metadataList01.txt', $serializedList);
		//echo '<pre>'.print_r($metadataList,true).'</pre>';	

		// Post CONTENTdm Catcher edit transaction 
		
		$param = array
		(
			'action'=>'edit',
			'cdmurl'=>$CDMURL,
			'username'=>$CDMUSERNAME,
			'password'=>$CDMPASSWORD,
			'license'=>$CDMLICENSE,
			'collection'=>$CDMALIAS,
			'metadata'=>$metadataWrapper
		);
		$processEdit =  $catcherws->processCONTENTdm ($param);
		print ("<hr><b>Edit process:</b>");
		print ("<pre>");
		print (htmlentities ($processEdit->return));
		print ("</pre>");
		
	}	
?>